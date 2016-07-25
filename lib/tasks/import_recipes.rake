namespace :import do
  task(:recipes, [:import_file_path] => :environment) do |t, args|
    require 'recipe_importer'
    RecipeImporter.init(args.import_file_path)
  end
end
