STDIN.each_line {|line|

  if /^http.*youtube.com.watch.*v=(?<video_id>.*)/ =~ line
    puts "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/#{video_id}\" frameborder=\"0\" allow=\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe>"

  elsif /^https:\/\/youtu.be\/(?<video_id>.*)/ =~ line
    puts "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/#{video_id}\" frameborder=\"0\" allow=\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe>"

  elsif /^http.*nicovideo.jp\/watch\/(?<video_id>[a-z]*[0-9]*)/ =~ line
    puts "<script type=\"application/javascript\" src=\"https://embed.nicovideo.jp/watch/#{video_id}/script?w=640&h=360\"></script>"

  elsif /^https:\/\/nico.ms\/(?<video_id>[a-z]*[0-9]*)/ =~ line
    puts "<script type=\"application/javascript\" src=\"https://embed.nicovideo.jp/watch/#{video_id}/script?w=640&h=360\"></script>"

  elsif /^https.*twitter.com\/(?<user_id>[^\/]*)\/status\/(?<status_id>[0-9]*)/ =~ line
    puts "<blockquote class=\"twitter-tweet\"><p lang=\"ja\" dir=\"ltr\"></p><a href=\"https://twitter.com/#{user_id}/status/#{status_id}?ref_src=twsrc%5Etfw\"></a></blockquote><script async src=\"https://platform.twitter.com/widgets.js\" charset=\"utf-8\"></script>"

  elsif /^(?<url>http.*)$/ =~ line
    puts "[#{url}](#{url})"

  elsif /^!(?<url>http.*)$/ =~ line
    title = `html-title #{url} | tr '\n' ' ' | tr \\| - | sed 's/ *$//g; s/^ *//g'`
    puts "[#{title}](#{url})"

  else
    puts line
  end
}
