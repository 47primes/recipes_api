object @cookbook
attributes :name, :description, :updated_at

node(:submitted_by) { |cookbook| cookbook.cook.username }

child :recipes do
  extends "recipes/show"
end
