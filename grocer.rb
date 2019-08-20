require 'pry'

beer = {"BEER" => {:price => 13.00, :clearance => false}}
beer_coupon = {:item => "BEER", :num => 2, :cost => 20.00}
beer_cart = [beer, beer, beer]
beer_coupons = [beer_coupon, beer_coupon]

def consolidate_cart(cart)
  
  # Get key names from cart
  
  cart_items = cart.map{|item| item.keys}
  key_names = []
  new_cart = {}
  
  i = 0
  while i < cart_items.length do
    key_names.push(cart_items[i][0])
    i += 1
  end
  
  # Count number of appereances
  # for each key name, put into 
  # hash
  
  key_count = Hash.new(0)
  key_names.each do |count|
    key_count[count] += 1
  end
  
  # Create array of unique keys
  
  unique_keys = key_names.uniq
  
  # For each item in the cart, 
  # if key exists, append the 
  # count for that key from 
  # key_count to cart
  
  transfer = cart.uniq
  
  transfer.length.times do |i|
    unique_keys.length.times do |j|
      if transfer[i][unique_keys[j]]
        new_cart[unique_keys[j]] = {price: transfer[i][unique_keys[j]][:price], clearance: transfer[i][unique_keys[j]][:clearance], count: key_count[unique_keys[j]]}
      end
    end
  end
  
  return new_cart
  
end

def apply_coupons(cart, coupons = [])
  
  if coupons != []
    
    coupon_keys = []
    
    coupons.length.times do |i|
      coupon_keys[i] = coupons[i][:item]
    end
    
    intersection = coupon_keys & cart.keys
    
    if intersection.empty?
      return cart
    end
    
    coupon_keys.length.times do |i|
      
      if cart[coupon_keys[i]][:count] >= coupons[i][:num]
        
        duplicate_coupons = coupon_keys.select{|n| n == coupon_keys[i]}.length
        eligible_coupons = 0
        
        while  (cart[coupon_keys[i]][:count] - coupons[i][:num]) >= 0 do
          cart[coupon_keys[i]][:count] -= coupons[i][:num]
          eligible_coupons += 1
          duplicate_coupons -= 1
        end
        
        binding.pry
        
        cart["#{coupon_keys[i]} W/COUPON"] = {
        price: (coupons[i][:cost]/coupons[i][:num]),
        clearance: cart[coupon_keys[i]][:clearance],
        count: eligible_coupons
        }
        
      end
        
    end
    
    return cart
    
  else
    
    return cart
    
  end
  
end

apply_coupons(consolidate_cart(beer_cart), beer_coupons)
# binding.pry

def apply_clearance(cart)
  
  items = cart.keys
  
  items.length.times do |i|
    if cart[items[i]][:clearance]
      cart[items[i]][:price] *= 0.8
      cart[items[i]][:price] = cart[items[i]][:price].round(2)
    end
  end
  
  return cart
  
end

def checkout(cart, coupons)
  
  final_cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  final_keys = final_cart.keys
  total = 0
  
  final_keys.length.times do |i|
    total += (final_cart[final_keys[i]][:price] * final_cart[final_keys[i]][:count])
  end
  
  if total > 100
    total *= 0.9
  end
  
  return total
  
end