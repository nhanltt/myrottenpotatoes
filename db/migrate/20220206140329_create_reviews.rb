class CreateReviews < ActiveRecord::Migration[7.0]
  def up
    create_table 'reviews' do |t|
      t.integer    'potatoes'
      t.text       'comments'
      t.references 'moviegoer'
      t.references 'movie'
    end
  end
  def down ; drop_table 'reviews' ; end
end
