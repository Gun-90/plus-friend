class KakaoController < ApplicationController
  def keyboard
    @keyboard = {
    type: "buttons",
    buttons: ["메뉴", "로또", "고양이", "효진 배그 전적","양재 배그 전적"]
    }
    render json: @keyboard
    
  end
  
  def message
    @text = "기본응답"
    @user_msg = params[:content]
    
    if @user_msg == '메뉴'
      @text = ["김밥", "20층", "돈가스"].sample
      
    elsif @user_msg == '로또'
      @text = (1..45).to_a.sample(6).sort.to_s
    elsif @user_msg == '고양이'
      @url = 'http://thecatapi.com/api/images/get?format=xml&type=jpg'
      @cat_xml = RestClient.get(@url)
      @cat_doc =  Nokogiri::XML(@cat_xml)
      @cat_url = @cat_doc.xpath("//url").text
    
    elsif @user_msg == '효진 배그 전적'
      @bag_url = 'https://pubg.op.gg/user/ZonnaBoTinDa?server=pc-kakao'
      @bag_html = RestClient.get(@bag_url)
      @bag_doc =  Nokogiri::HTML(@bag_html)
      @bag_url = @bag_doc.css('div.recent-matches__avg-rank').text.strip.chomp
      @text = "최근 20게임 평균"+ @bag_url+ "등\n"+'상세정보 : '+'https://pubg.op.gg/user/ZonnaBoTinDa?server=pc-kakao'
    
    elsif @user_msg == '양재 배그 전적'
      @bag_url = 'https://pubg.op.gg/user/humbazzz?server=pc-kakao'
      @bag_html = RestClient.get(@bag_url)
      @bag_doc =  Nokogiri::HTML(@bag_html)
      @bag_url = @bag_doc.css('div.recent-matches__avg-rank').text.strip.chomp
      @text = "최근 20게임 평균"+ @bag_url+ "등\n"+'상세정보 : '+'https://pubg.op.gg/user/humbazzz?server=pc-kakao'
    end
    
    @return_msg ={
      :text => @text
    }
    
    @return_msg_photo ={
      text: "나만 고양이 없어",
      photo: {
        url: @cat_url,
        width: 720,
        height: 630
        
      }
    }
    @return_keyboard ={
    type: "buttons",
    buttons: ["메뉴", "로또", "고양이", "효진 배그 전적", "양재 배그 전적" ]
    }
    
    if @user_msg == "고양이"
      @result = {
        message: @return_msg_photo ,
        keyboard: @return_keyboard
      }

    else
      @result = {
        message: @return_msg ,
        keyboard: @return_keyboard
      }
      
    end
    render json: @result
  end
  
  
  
  
  def friend_add
    
    User.create(chat_room: 0, user_key: params[:user_key])
    render nothing: true
  end
  
  def friend_delete
    User.find_by(user_key: params[:user_key]).destroy
    render nothing: true
  end
  
  def chat_room
    @user =  User.find_by(user_key: params[:user_key])
    @user.plus
    @user.save
    render nothing: true
  end
end
