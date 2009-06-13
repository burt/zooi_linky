# desc "Explaining what the task does"
# task :zooi_linky do
#   # Task goes here
# end
namespace :zooi_linky do
  desc "Sync extra files from zooi_linky plugin."
  task :sync do
    system "rsync -ruv vendor/plugins/zooi_linky/db/migrate db"
    system "rsync -ruv vendor/plugins/zooi_linky/public ."
  end
end