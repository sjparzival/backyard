class TagsController < ApplicationController
  before_action :authenticate_user

  def index
    # so the question is, list them tags by user session or by decoding the token
    @tags = Tag.where(trigger_params.merge(user_id: current_user.id))

    if(!params[:block_id])
      @tags = @tags.map do |tag|
        tag = tag.as_json
        tag.merge({conquered: conquered?(tag)})
      end
    end

    render json: @tags, status: :ok
  end

  def create
    @tag = Tag.find_or_create_by(trigger_params.merge(user_id: current_user.id))
    render json: @tag, status: :ok
  end

  def update
    @tag = Tag.find(params[:id])
    @tag.update(trigger_params)
    json_response(Tag.find(params[:id]))
  end

  def edit
  end

  def destroy
  end

  def conquered?(tag)
    user_blocks = Block.where(user_id: current_user.id)
    if(user_blocks.count <= 15)
      return false
    end

    all_tags = user_blocks.order(day: :desc).first(14).map do |block|
      block.tags.to_a
    end

    all_tags = all_tags.compact.uniq.flatten

    all_tags.each do |tag_item|
      next unless tag_item.present?

      if(tag_item.value == tag['value'])
        return false
      end
    end

    true
  end

  private

  def trigger_params
    params.permit(:value, :id, :block_id, :user_id)
  end
end
