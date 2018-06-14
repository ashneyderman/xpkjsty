defmodule TCBView.Sorting do

  # O n^2 in the worst case
  # O n log n on average
  def quick_sort(nil), do: nil
  def quick_sort([]), do: []
  def quick_sort([]), do: []
  def quick_sort([_]=r), do: r
  def quick_sort([l, r]) when l <= r, do: [l, r]
  def quick_sort([r, l]) when l > r, do: [r, l]
  def quick_sort([pivot | rest]) do
    {left, right} = quick_split(rest, pivot)
    quick_sort(left) ++ [pivot] ++ quick_sort(right)
  end

  def quick_split([v]=list, pivot) when v < pivot, do: {list, []}
  def quick_split([_]=list, pivot), do: {[], list}
  def quick_split(list, pivot) do
    list |> Enum.reduce({[], []}, 
              fn(val, {left, right}) -> 
                if(val < pivot) do
                  {[val | left], right}
                else
                  {left, [val | right]}
                end
              end)
  end

  # O(n log n)
  def merge_sort(nil), do: nil
  def merge_sort([]), do: []
  def merge_sort([_]=r), do: r
  def merge_sort([l, r]) when l <= r, do: [l, r]
  def merge_sort([r, l]) when l > r, do: [r, l]
  def merge_sort(list) when is_list(list) do
    length = Enum.count(list)
    left_half  = Enum.slice(list, 0, round(length/2))
    right_half = Enum.slice(list, round(length/2)..length)
    do_merge(merge_sort(left_half), merge_sort(right_half))
  end

  def do_merge([], []), do: []
  def do_merge([], right), do: right
  def do_merge(left, []), do: left
  def do_merge([left_head | left_tail], [right_head | _] = right) 
    when left_head <= right_head do
    [left_head | do_merge(left_tail, right)]
  end
  def do_merge([left_head | _] = left, [right_head | right_tail]) 
    when left_head > right_head do
    [right_head | do_merge(left, right_tail)]
  end

  def insert_sort(list),
    do: do_insert_sort([], list)

  def do_insert_sort(result, []), do: result
  def do_insert_sort(result, [h | t]) do
    do_insert_sort(do_insert_item(result, h), t)
  end

  def do_insert_item([], item), do: [item]
  def do_insert_item([h | t], item) when h < item, do: [h | do_insert_item(t, item)]
  def do_insert_item([h | _]=l, item), do: [item | l]

end
