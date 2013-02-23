module HomeHelper
  def shorten_with_bitly(l, user)
        bitly = Bitly.new('lavanvicky','R_c90602b92076e1473d8c58d0b2271d9a')
        page_url = bitly.shorten("#{Rails.root}/public/#{user}/#{l}")
        shorten_url = page_url.short_url
  end
end
