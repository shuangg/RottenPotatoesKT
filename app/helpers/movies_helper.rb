module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end

  def sortable_column(column, column_text="")
    if sort==column.to_s
      link_to column_text.to_s, {:sort => column.to_s}, {:id => 'title_header', :class => 'hilite'}
    else
      link_to column_text.to_s, {:sort => column.to_s}, :id => 'title_header'
    end
  end
end
