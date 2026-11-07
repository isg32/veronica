plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing: set by build_signed.sh (from .env) or the release
// workflow (from repository secrets), never committed. Without them,
// release builds fall back to the debug key, so `flutter build apk
// --release` still works with no setup.
val releaseStoreFile = System.getenv("VERONICA_KEYSTORE_FILE")?.let { file(it) }
val releaseStorePassword = System.getenv("VERONICA_KEYSTORE_PASSWORD")?.takeIf { it.isNotEmpty() }
val releaseKeyPassword =
    System.getenv("VERONICA_KEY_PASSWORD")?.takeIf { it.isNotEmpty() } ?: releaseStorePassword
val releaseKeyAlias = System.getenv("VERONICA_KEY_ALIAS")?.takeIf { it.isNotEmpty() } ?: "upload"
val canSignRelease = releaseStorePassword != null && releaseStoreFile?.exists() == true

android {
    namespace = "com.isg32.veronica"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // NewPipeExtractor uses newer Java APIs than Android 7 has.
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.isg32.veronica"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = releaseKeyAlias
            keyPassword = releaseKeyPassword
            storeFile = releaseStoreFile
            storePassword = releaseStorePassword
        }
    }

    buildTypes {
        release {
            signingConfig = if (canSignRelease) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Shizuku: grants greyscale's WRITE_SECURE_SETTINGS on the phone itself,
    // over Wireless debugging, so no computer is needed (see docs/PLAN.md).
    implementation("dev.rikka.shizuku:api:13.1.5")
    implementation("dev.rikka.shizuku:provider:13.1.5")

    // YouTube mantras: NewPipe's extractor (GPL-3.0, like Veronica) finds
    // a stream when the Dart extractor can't (see YouTubeChannel.kt).
    implementation("com.github.TeamNewPipe:NewPipeExtractor:v0.27.0")
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
