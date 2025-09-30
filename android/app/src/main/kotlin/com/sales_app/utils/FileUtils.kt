package com.sales_app.utils

//package com.euronovate.mobile.ocrvision.sample.utils

import android.Manifest
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import android.widget.Toast
import androidx.core.content.ContextCompat
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.withContext
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.InputStream
import java.io.OutputStream

suspend fun saveMediaToStorage(context: Context, bitmap: Bitmap) : Uri? {

    val filename = "facematch.jpg" // overwrite the image
    var fos: OutputStream? = null
    var imageUri: Uri? = null
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
        context.contentResolver?.also { resolver ->

            val contentValues = ContentValues().apply {

                put(MediaStore.MediaColumns.DISPLAY_NAME, filename)
                put(MediaStore.MediaColumns.MIME_TYPE, "image/jpg")
                put(
                    MediaStore.MediaColumns.RELATIVE_PATH,
                    Environment.DIRECTORY_DCIM
                )
            }
            imageUri = resolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)

            fos = imageUri?.let { with(resolver) { openOutputStream(it) } }
        }
    } else {
        val imagesDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM)
        val image = File(imagesDir, filename).also { fos = FileOutputStream(it) }
        Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE).also { mediaScanIntent ->
            imageUri = Uri.fromFile(image)
            mediaScanIntent.data = imageUri
            context.sendBroadcast(mediaScanIntent)
        }
    }

    withContext(Dispatchers.IO) {
        fos?.use {
            val success = async(Dispatchers.IO) {
                bitmap.compress(Bitmap.CompressFormat.JPEG, 100, it)
            }
            if (success.await()) {
                withContext(Dispatchers.Main) {
                    Toast.makeText(context, "Image saved into gallery", Toast.LENGTH_SHORT).show()
                }
            }
        }
    }

    return imageUri
}

fun copyInDownloads(file: File, context: Context) {

    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) {
        if (ContextCompat.checkSelfPermission(context, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
            val out = File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).toString())
            copyFileToFolder(file, out, file.name)
        }
    } else {
        val resolver = context.contentResolver
        val contentValues = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, file.name)
            put(MediaStore.MediaColumns.MIME_TYPE, "application/pdf")
        }

        try {
            val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, contentValues)

            uri?.let { unwrappedUri ->
                resolver.openOutputStream(unwrappedUri).use { outputStream ->
                    outputStream?.let { unwrappedOutputStream ->
                        val inputStream: InputStream = FileInputStream(file)
                        copyFile(inputStream, unwrappedOutputStream)
                    }
                }
            }
        } catch (ex: Exception) {
            Log.e("FileUtils", ex.message, ex)
        }
    }
}

private fun copyFileToFolder(inputFile: File, folder: File, outputFileName: String) {
    if (folder.isDirectory) {
        val inputStream: InputStream = FileInputStream(inputFile)
        val outputFile = File(folder, outputFileName)
        val out: OutputStream = FileOutputStream(outputFile)
        copyFile(inputStream, out)
    }
}

private fun copyFile(inputStream: InputStream, out: OutputStream) {
    val buffer = ByteArray(1024)
    var read: Int
    while (inputStream.read(buffer).also { read = it } != -1) {
        out.write(buffer, 0, read)
    }
}