module InlineSvg
  class AssetFile
    class FileNotFound < IOError; end
    UNREADABLE_PATH = ''

    def self.named(filename)
      asset_path = FindsAssetPaths.by_filename(filename) rescue nil
      asset_path = FindsPublicPaths.by_filename(filename) if asset_path.nil? rescue nil
      File.read(asset_path || UNREADABLE_PATH)
    end
  end
end
