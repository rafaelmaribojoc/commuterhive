pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://api.mapbox.com/downloads/v2/releases/maven")
            credentials {
                username = "mapbox"
                
                // Read from local.properties or fallback to .env
                val localProperties = java.util.Properties()
                val localPropsFile = file("local.properties")
                if (localPropsFile.exists()) {
                    localPropsFile.inputStream().use { localProperties.load(it) }
                }
                var token = localProperties.getProperty("MAPBOX_DOWNLOAD_TOKEN", "")
                
                if (token.isEmpty()) {
                    val envFile = file("../.env")
                    if (envFile.exists()) {
                        envFile.readLines().forEach { line ->
                            if (line.startsWith("MAPBOX_ACCESS_TOKEN=")) {
                                token = line.substringAfter("=").trim()
                            }
                        }
                    }
                }
                password = token
            }
            authentication {
                create<BasicAuthentication>("basic")
            }
        }
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")
