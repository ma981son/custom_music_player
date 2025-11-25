package com.example.music_player_final

import android.content.ContentUris
import android.content.Context
import android.database.Cursor
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.provider.MediaStore
import android.util.Base64
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.ByteArrayOutputStream

class MediaStorePlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "media_store")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getAllAudioFiles" -> {
                val tracks = getAllAudioFiles()
                result.success(tracks)
            }
            "getAlbumArt" -> {
                val albumId = call.argument<Long>("albumId")
                if (albumId != null) {
                    val albumArt = getAlbumArtBase64(albumId)
                    result.success(albumArt)
                } else {
                    result.error("INVALID_ARGUMENT", "albumId is required", null)
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun getAllAudioFiles(): List<Map<String, Any?>> {
        val tracks = mutableListOf<Map<String, Any?>>()

        val projection = arrayOf(
            MediaStore.Audio.Media._ID,
            MediaStore.Audio.Media.TITLE,
            MediaStore.Audio.Media.ARTIST,
            MediaStore.Audio.Media.ALBUM,
            MediaStore.Audio.Media.ALBUM_ID,
            MediaStore.Audio.Media.DATA,
            MediaStore.Audio.Media.DURATION,
            MediaStore.Audio.Media.DATE_ADDED
        )

        val selection = null  // Get all audio files
        val sortOrder = "${MediaStore.Audio.Media.TITLE} ASC"

        val cursor: Cursor? = context.contentResolver.query(
            MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
            projection,
            selection,
            null,
            sortOrder
        )

        cursor?.use {
            val idColumn = it.getColumnIndexOrThrow(MediaStore.Audio.Media._ID)
            val titleColumn = it.getColumnIndexOrThrow(MediaStore.Audio.Media.TITLE)
            val artistColumn = it.getColumnIndexOrThrow(MediaStore.Audio.Media.ARTIST)
            val albumColumn = it.getColumnIndexOrThrow(MediaStore.Audio.Media.ALBUM)
            val albumIdColumn = it.getColumnIndexOrThrow(MediaStore.Audio.Media.ALBUM_ID)
            val pathColumn = it.getColumnIndexOrThrow(MediaStore.Audio.Media.DATA)
            val durationColumn = it.getColumnIndexOrThrow(MediaStore.Audio.Media.DURATION)

            while (it.moveToNext()) {
                val id = it.getLong(idColumn)
                val title = it.getString(titleColumn) ?: "Unknown"
                val artist = it.getString(artistColumn) ?: "Unknown Artist"
                val album = it.getString(albumColumn)
                val albumId = it.getLong(albumIdColumn)
                val path = it.getString(pathColumn)
                val duration = it.getLong(durationColumn)

                tracks.add(
                    mapOf(
                        "id" to id.toString(),
                        "title" to title,
                        "artist" to artist,
                        "album" to album,
                        "filePath" to path,
                        "duration" to duration,
                        "albumId" to albumId  // Return albumId to fetch art later
                    )
                )
            }
        }

        return tracks
    }

    private fun getAlbumArtBase64(albumId: Long): String? {
        try {
            val albumArtUri = ContentUris.withAppendedId(
                Uri.parse("content://media/external/audio/albumart"),
                albumId
            )

            val inputStream = context.contentResolver.openInputStream(albumArtUri)
            inputStream?.use { stream ->
                val bitmap = BitmapFactory.decodeStream(stream)
                
                // Resize bitmap to reduce size (100x100 for thumbnails)
                val resized = Bitmap.createScaledBitmap(bitmap, 100, 100, true)
                
                val outputStream = ByteArrayOutputStream()
                resized.compress(Bitmap.CompressFormat.JPEG, 85, outputStream)
                val byteArray = outputStream.toByteArray()
                
                // CHANGED: Use NO_WRAP instead of DEFAULT to remove newlines
                return Base64.encodeToString(byteArray, Base64.NO_WRAP)  // ← Changed here!
            }
        } catch (e: Exception) {
            return null
        }
        
        return null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}