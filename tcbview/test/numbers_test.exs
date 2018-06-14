defmodule TCBViewNumbersTest do
  use ExUnit.Case
  import TCBView.Numbers
  
  test "greatest common divider" do
    assert 15 = gcd(15, 45)
    assert 5 = gcd(15, 25)
  end

end
