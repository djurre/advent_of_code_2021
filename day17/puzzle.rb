tx1, tx2, ty1, ty2 = File.read('input.txt').scan(/-?\d+/).map(&:to_i)

points = Hash.new([])
(0..tx2).each do |px|
  (ty1..ty1.abs).each do |py|
    x, y, vx, vy = 0, 0, px, py

    while x <= tx2 && y >= ty1
      points[[px, py]] += [[x, y]]
      x += vx; y += vy
      vx, vy = [0, vx - 1].max, vy - 1
    end
  end
end

points.select! { |_, points| x, y = points[-1]; x >= tx1 && x <= tx2 && y >= ty1 && y <= ty2 }
pp points.dup.transform_values { |points| points.max_by { |p| p[1] }[1] }.invert.max[0]
pp points.count
