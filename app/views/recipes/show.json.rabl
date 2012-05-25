object @recipe
attributes :name, :category, :ingredients, :directions, :updated_at

node(:submitted_by) { |recipe| recipe.cook.username }

node(:cookbook) { |recipe| recipe.cookbook.name if recipe.cookbook }