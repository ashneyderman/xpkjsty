defmodule TCBViewSortingTest do
  use ExUnit.Case
  import TCBView.Sorting

  test "merge sort" do
    assert [] = do_merge([], [])
    assert [1] = do_merge([1], [])
    assert [2] = do_merge([], [2])
    assert [3, 4, 5] = do_merge([4, 5], [3])
    assert [3, 4, 5] = do_merge([4, 5], [3])
    assert [1, 3, 4, 5] = do_merge([4, 5], [1, 3])

    assert [] = merge_sort([])
    assert [1] = merge_sort([1])
    assert [1, 2] = merge_sort([1, 2])
    assert [1, 1] = merge_sort([1, 1])
    assert [1, 2] = merge_sort([2, 1])
    assert [1, 2, 4, 5] = merge_sort([2, 1, 5, 4])
    assert [1, 2, 4, 5, 6, 7] = merge_sort([7, 2, 1, 6, 5, 4])
    assert [1, 2, 4, 5, 6, 7, 10] = merge_sort([7, 10, 2, 1, 6, 5, 4])
  end

  test "quick sort" do
    assert {[], []} = quick_split([], 2)
    assert {[], [2]} = quick_split([2], 1)
    assert {[1], []} = quick_split([1], 2)
    assert {[3, 2 , 1], []} = quick_split([1, 2, 3], 4)
    assert {[1], [3]} = quick_split([3, 1], 2)

    assert [] = quick_sort([])
    assert [1] = quick_sort([1])
    assert [1, 2] = quick_sort([1, 2])
    assert [1, 1] = quick_sort([1, 1])
    assert [1, 2] = quick_sort([2, 1])
    assert [1, 2, 4, 5] = quick_sort([2, 1, 5, 4])
    assert [1, 2, 4, 5, 6, 7] = quick_sort([7, 2, 1, 6, 5, 4])
    assert [1, 2, 4, 5, 6, 7, 10] = quick_sort([7, 10, 2, 1, 6, 5, 4])
  end

  test "insert sort" do
    assert [] = insert_sort([])
    assert [1] = insert_sort([1])
    assert [1, 2] = insert_sort([1, 2])
    assert [1, 1] = insert_sort([1, 1])
    assert [1, 2] = insert_sort([2, 1])
    assert [1, 2, 4, 5] = insert_sort([2, 1, 5, 4])
    assert [1, 2, 4, 5, 6, 7] = insert_sort([7, 2, 1, 6, 5, 4])
    assert [1, 2, 4, 5, 6, 7, 10] = insert_sort([7, 10, 2, 1, 6, 5, 4])
  end

end
