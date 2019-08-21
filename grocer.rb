def consolidate_cart(cart)
  # code here
  hash = {}
  cart.each_with_index {|value, index|
    item_name = cart[index].keys.first
    item_values = cart[index].values.first
    
    if not hash.keys.include?(item_name)
      hash[item_name] = item_values
      hash[item_name][:count] = 1
    else
      hash[item_name][:count] += 1
    end
  }
  return hash
end

def apply_coupons(cart, coupons)
  # code here
  coupons.each_with_index {|value, index|
    coupon_item_name = coupons[index][:item]
    coupon_item_num = coupons[index][:num]
    coupon_item_cost = coupons[index][:cost]
    
    if cart.keys.include?(coupon_item_name)
      if cart[coupon_item_name][:count] >= coupon_item_num 
        cart[coupon_item_name][:count] -= coupon_item_num

        if not cart["#{coupon_item_name} W/COUPON"]
          cart["#{coupon_item_name} W/COUPON"]  = {}
          cart["#{coupon_item_name} W/COUPON"][:count] = coupon_item_num
          cart["#{coupon_item_name} W/COUPON"][:price] = coupon_item_cost / coupon_item_num
          cart["#{coupon_item_name} W/COUPON"][:clearance] = cart[coupon_item_name][:clearance]
        else
          cart["#{coupon_item_name} W/COUPON"][:count] += coupon_item_num
        end
      end
    end
  }
  
  return cart
end

def apply_clearance(cart)
  # code here
  cart.each_key do |key|
    if cart[key][:clearance] == true
      cart[key][:price] = (cart[key][:price] * 0.8).round(2)
    end
  end
  
  return cart
end

def checkout(cart, coupons)
  # code here
  final = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  
  total = final.reduce(0) do |sum, (key, value)|
    sum += (value[:price] * value[:count])
  end
  
  total *= 0.9 if total > 100
  return total
end
