Dev Setup:

Install:
  1. IDE (VS Code, IntelliJ IDEA, etc.)
  2. Android Studio (Android SDK and Emulator)
  3. Flutter SDK


VS Code Setup:
  1. Install Flutter extension
  2. Open 4YP/sku_app
  3. Open Cmd:
      - cd 4YP/sku_app 
      - flutter doctor 
      - flutter pub get
  4. Open sku_app/lib/main.dart to run
  

IntelliJ Setup:
  1. Open project in IntelliJ (.../4YP/App)
  2. File --> Settings --> Plugins --> Search (Flutter) --> install
  3. File --> Settings --> Languages & Freameworks --> Flutter --> Set Flutter SDK path
  4. Open App\lib\main.dart you should be prompted to run flutter pub get
  5. File --> Project Structure --> Project --> Project SDK (C:\Users\USERNAME\AppData\Local\Android\Sdk)
  6. File --> Project Structure --> Project --> Project Compiler Output = ...\4YP\App\build
  7. File --> Project Structure --> Modules --> Dependencies --> Module SDK = Project SDK