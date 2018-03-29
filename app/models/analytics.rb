class Analytics
  FIRE_MAPPINGS = {
    'None' => 0,
    'Light' => 1,
    'Moderate' => 2,
    'High'=> 3,
    'Very High' => 4
  }.with_indifferent_access

  def self.most_triggered(current_user)
    return unless current_user.blocks.present?
    {
      week: week_data(current_user),
      month: month_data(current_user),
      all: all_data(current_user)
    }
  end

  def self.average_rating(current_user)
    return unless current_user.blocks.present?
    {
      week: rating(current_user, 7)  ,
      month: rating(current_user, 30)
    }
  end

  def self.average_ice(current_user)
    return unless current_user.blocks.present?
    {
      week: ice(current_user, 7),
      month: ice(current_user, 30)
    }
  end

  def self.average_fire(current_user)
    return unless current_user.blocks.present?
    {
      week: fire(current_user, 7),
      month: fire(current_user, 30)
    }
  end

  def self.fire(current_user, days_count)
    user_blocks = current_user.blocks.where("created_at > ?", Time.now - days_count.days)

    fire = []
    user_blocks.each do |block|
      fire.push(FIRE_MAPPINGS[block.fire]);
    end

    sum = fire.inject(0){|sum,x| sum + x }

    FIRE_MAPPINGS.key((sum.to_f/fire.count).ceil).to_s
  end

  def self.ice(current_user, days_count)
    user_blocks = current_user.blocks.where("created_at > ?", Time.now - days_count.days)

    ice = []
    user_blocks.each do |block|
      if(block.ice)
        ice.push(block.ice)
      else
        ice.push(0)
      end
    end

    sum = ice.inject(0){|sum,x| sum + x }
    (sum/ice.count).round
  end

  def self.rating(current_user, days_count)
    user_blocks = current_user.blocks.where("created_at > ?", Time.now - days_count.days)

    ratings = []
    user_blocks.each do |block|
      if(block.rating)
        ratings.push(block.rating)
      else
        ratings.push(0)
      end
    end

    sum = ratings.inject(0){|sum,x| sum + x }
    (sum/ratings.count).round
  end

  def self.week_data(current_user)
    user_blocks = current_user.blocks.where("created_at > ?", Time.now - 7.days)

    all_tags = []
    user_blocks.each do |block|
      block.tags.each do |tag|
        all_tags.push(tag.value)
      end
    end

    freq = all_tags.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    all_tags.max_by { |v| freq[v] }
  end

  def self.month_data(current_user)
    user_blocks = current_user.blocks.where("created_at > ?", Time.now - 30.days)

    all_tags = []
    user_blocks.each do |block|
      block.tags.each do |tag|
        all_tags.push(tag.value)
      end
    end

    freq = all_tags.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    all_tags.max_by { |v| freq[v] }
  end

  def self.all_data(current_user)
    user_blocks = current_user.blocks

    all_tags = []
    user_blocks.each do |block|
      block.tags.each do |tag|
        all_tags.push(tag.value)
      end
    end

    freq = all_tags.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    all_tags.max_by { |v| freq[v] }
  end
end