# Image Resizing Script

## 概要

このスクリプトは、`before` ディレクトリ内の画像をリサイズし、リサイズ後の画像を `after` ディレクトリに保存します。以下の要件に基づいて動作します。

- **リサイズオプション**:
  1. オプション1:
     - 横幅 **1800px**（ファイル名に `@2x` を付与）
     - 横幅 **900px**（ファイル名に変更なし）
  2. オプション2:
     - 横幅 **1880px**（ファイル名に `@2x` を付与）
     - 横幅 **940px**（ファイル名に変更なし）
- **対応するファイル形式**: `.jpg`, `.png`, `.psd`
- **出力形式**: すべて `.jpg` に変換
- **ログ**: 実行中の処理ログは `resize_log.txt` に記録されます。

---

## 前提条件

スクリプトを実行するには以下の環境が必要です：

1. **ImageMagick** がインストールされていること  
   - 確認コマンド: `magick -version`
   - **macOS**:  
     ```bash
     brew install imagemagick
     ```
   - **Linux (Debian/Ubuntu)**:  
     ```bash
     sudo apt-get install imagemagick
     ```
   - **Windows**:  
     [ImageMagick公式サイト](https://imagemagick.org/script/download.php) からインストーラーをダウンロードしてインストールしてください。

---

## 使用方法

1. **入力画像を配置**  
   リサイズ対象の画像を `before` ディレクトリに配置します。

2. **スクリプトを実行**  
   以下のコマンドをターミナルで実行します。
   ```bash
   ./resize_images.sh
   ```

3. **サイズオプションの選択**
   プロンプトが表示されたら、希望のサイズオプションを選択します：
   - `1`: 1800px(@2x) / 900px
   - `2`: 1880px(@2x) / 940px

4. **出力の確認**
   - リサイズされた画像は `after` ディレクトリに保存されます
   - 処理ログは `resize_log.txt` に記録されます