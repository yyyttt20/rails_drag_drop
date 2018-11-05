class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def str_slashes(str)
    #avoid_words = ['in','on','(',')','and','exec','insert','select','delete','update','count','*','%','chr','mid','master','truncate','char','declare']
    unless str.empty? and str.blank?
      # don't sanitize on internal screens (related to DJ-685 special topic)
      if params[:controller].blank? or params[:controller].index("administrators") != 0
        #if avoid_words.find{|aw| aw == str.downcase}
          #str = ''
        #end
        str = str.gsub('<script', '&lt;script')
        # DJ-824 to nullify cracking access
        str = "" if str.match("\\.\\.\\/")  # '../'
        str = "" if str.match("\\.\\\\\\\\")  # '.\\'
        str = "" if str.match("\\/etc\\/passwd")
        #str = str.gsub('>', '&gt;')
        #str = str.gsub(/['"]/, '&quot;')
        #str = str.lstrip
        #str = str.delete("\n\r")
        #str = str.delete(" ")

        # WAWW-141 check string is suspicious or not, from the point of view of
        # SQL injection and simliar vulnerbilities
        action = params[:action]
        if params[:controller] == "waww" && (action == "get_word" || action == "get_location" )
          # characters are from email report from GSX on 20170216
          # always detected, like 'is detected : get_word' so added conditions
          if str && str.match(/[\|;\'\"%_&\$]/) && str != "get_word" && str != "get_location"
            logger.error "def str_hashes(application.rb) - suspicious character is detected(action: #{action}) : #{str}"
            str = ""
          end
        end
      end
    end
    return str
  end

  def get_user_agent
    request.env['HTTP_USER_AGENT'].nil? ? '' : request.env['HTTP_USER_AGENT']
  end


  def filter_hash(target)
    new_hash = Hash.new
    target.each do |t, item|
      case item.class.to_s
      when 'String'
        new_hash[t.to_sym] = str_slashes(item)
      when 'Array'
        new_hash[t.to_sym] = filter_array(item)
      when 'HashWithIndifferentAccess'
        new_hash[t.to_sym] = filter_hash(item)
      else
        new_hash[t.to_sym] = item
      end
    end
    return new_hash
  end

  def get_date(prefix,default_month,default_day)
      yy = params["#{prefix}_year"].to_i
      if yy > 1900
          mm = params["#{prefix}_month"]
          dd = params["#{prefix}_day"]
          if mm.blank? or mm.to_i == 0
              mm = default_month
          else
              mm = mm.to_i
          end
          if dd.blank? or dd.to_i == 0
              dd = default_day
          else
              dd = dd.to_i
          end
          mm = 1 if mm < 1
          mm = 12 if mm > 12
          dd = 1 if dd < 1
          dd = 31 if dd > 31
          Time.local(yy,mm,dd)
      end
  end

  def get_referer
    referer = request.env['HTTP_REFERER'].nil? ? '' : request.env['HTTP_REFERER']
    return referer if referer.blank?
    url_domain = referer.slice(/\/\/.*?\//)
    if url_domain.nil?
      # If the above failed, it means the url only has the http and the domain so we delete the http(s)://
      url_domain = referer.gsub(/https?:\/\//, '')
    else
      # Or we erase the / from the url
      url_domain.gsub!(/\//, '')
    end
  end
 