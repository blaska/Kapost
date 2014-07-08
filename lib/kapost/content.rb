module Kapost
  module Content

    CREATE_PARAMS = [
      :title, :idea, :content, :assignee_id, :privacy, :invitee_ids, :is_draft,
      :campaign_ids, :submission_deadline, :publish_deadline, :payment_type, :payment_fixed_rate, :tags, :external_file_url,
      :persona_ids, :stage_ids, :content_type_id, :custom_fields
    ]
    LIST_PARAMS = [
      :detail, :page, :per_page, :user_id, :campaign_id, :category, :include_empty_categories,
      :date_type, :start, :end, :listener_id, :content_type_id, :search, :content_number, :state
    ]
    UPDATE_PARAMS = [:id, :reject_reason, :operation] + CREATE_PARAMS
    SHOW_PARAMS   = [:id, :detail]
    DELETE_PARAMS = [:id]
    CONTENT_PATH  = 'content'

    # Creates a piece of content
    #
    # @param [Hash] params Parameters
    def create_content(params)
      post(CONTENT_PATH, params) if validate_params(params)
    end

    # Lists content
    #
    # @param [Hash] params Parameters
    def list_content(params)
      get(CONTENT_PATH, params) if validate_params(params)
    end

    # Shows a piece of content
    #
    # @param [Hash] params Parameters
    def show_content(params)
      get(set_path(params[:id]), params) if validate_params(params)
    end

    # Updates a piece of content
    #
    # @param [Hash] params Parameters
    def update_content(params)
      put(set_path(params[:id]), params) if validate_params(params)
    end

    # Deletes a piece of content
    #
    # @param [Hash] params Parameters
    def delete_content(params)
      delete(set_path(params[:id]), params) if validate_params(params)
    end

    private

    # Sets a the path to a specific piece of content
    #
    # @param [String] id ID or slug of the content
    # @return [String] Content path
    def set_path(id)
      [CONTENT_PATH, id].join('/')
    end

    # Validates correct parameters are being used
    #
    # @private
    # @param [Hash] params Hash of parameters
    # @return [true|false]
    def validate_params(params)
      keys = params.keys.sort

      # Is this anywhere near a good idea or am I being too cute here?
      operation = caller[0][/`([^']*)'/, 1]

      case operation
      when 'create_content'
        keys - CREATE_PARAMS.sort == []
      when 'list_content'
        keys - LIST_PARAMS.sort == []
      when 'show_content'
        keys - SHOW_PARAMS.sort == []
      when 'update_content'
        keys - UPDATE_PARAMS.sort == []
      when 'delete_content'
        keys - DELETE_PARAMS.sort == []
      else raise ArgumentError, "Operation: #{operation} not supported"
      end
    end
  end
end