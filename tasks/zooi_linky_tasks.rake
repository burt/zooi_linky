namespace :zooi_linky do
  desc "Sync extra files from zooi_linky plugin."
  task :sync do
    system "rsync -ruv vendor/plugins/zooi_linky/db/migrate db"
    system "rsync -ruv vendor/plugins/zooi_linky/public ."
  end
end