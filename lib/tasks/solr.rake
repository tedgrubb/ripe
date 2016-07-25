require 'yaml'
require 'fileutils'
namespace :solr do
  
  task :start do
    system "script/solr start"  
  end
  
  task :stop do
    system "script/solr stop"      
  end
  
  
  task :restart do
    system "script/solr restart"      
  end

  desc "Delete the search index"
  task :clean => :environment do
    FileUtils.rm_rf "#{RAILS_ROOT}/solr/indexes/#{RAILS_ENV}/index"
  end
  
  
  desc "Snapshots the current index"
  task :snapshot => :environment do
    name = "snapshot.#{Time.now.strftime('%m-%d')}.#{Time.now.to_i}"
    temp = "temp-#{name}"
    
    system(<<-EOS)
    mkdir -p #{SOLR_ROOT}/index &&
    gcp -lr #{SOLR_ROOT}/index #{SOLR_ROOT}/#{temp} &&
    mv #{SOLR_ROOT}/#{temp} #{SOLR_ROOT}/#{name} &&
    gln -nfs #{SOLR_ROOT}#{name} #{SOLR_ROOT}/latest_snapshot
    EOS
    # rm #{SOLR_ROOT}/#{temp}
  end
  
  
  desc "build and install a new solr war fle"
  task :build => :environment do
    Dir.chdir("#{RAILS_ROOT}/vendor/solr_src") do
      result = `ant dist`
      if $?.success?
        result_file = Dir['dist/*.war'].first
        FileUtils.cp(result_file, "#{RAILS_ROOT}/vendor/solr/webapps/solr.war")
        puts "#{result_file} successfully copied into /vendor/solr/webapps"
      else
        puts "Couldnt build solr"
        puts result
      end
    end
  end
  
  
  def pid_file
    "#{RAILS_ROOT}/tmp/pids/solr.#{RAILS_ENV}.pid"
  end
  
  def solrized
    {:people => 'User', :topics => 'Topic', :companies => 'Company', :products => 'Product'}
  end
  
  namespace :index do
    solrized.each do |name, klassname|
      desc "rebuild solr index for #{klassname}"
      task name => :environment do

        klass = klassname.constantize
        pager = klass.rebuild_solr_index 100

      end #task
    end #each loop
    
    desc "rebuild all solr indexes (#{solrized.values.to_sentence})"
    task :all => solrized.keys.map { |name| "index:#{name}" }
  end #namespace
end