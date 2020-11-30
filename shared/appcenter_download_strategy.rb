require 'download_strategy'
require 'json'
require 'net/http'
require 'uri'

class AppCenterDownloadStrategy < CurlDownloadStrategy
  private def _fetchJson(url)
    uri = URI(url)

    req = Net::HTTP::Get.new(uri)

    res =
      Net::HTTP.start(
        uri.host,
        uri.port,
        use_ssl: uri.scheme == 'https'
      ) { |http| http.request(req) }

    return JSON.parse(res.body)
  end

  private def _fetch(url:, resolved_url:)
    _, owner, app =
      Regexp.new(
        "^https://install.appcenter.ms/users/([\\w-]*)/apps/([\\w-]*)/distribution_groups/public$"
      ).match(url).to_a

    releases_url =
      "https://install.appcenter.ms/api/v0.1/apps/#{owner}/#{
        app
      }/distribution_groups/public/public_releases"

    ohai "Fetching #{releases_url}"

    matched = _fetchJson(releases_url).find { |i| i['version'] == version }

    if matched == nil
      $stderr.puts "No matched version #{version} found for #{owner}/#{app}"
      raise CurlDownloadStrategyError, url
    end

    release_url =
      "https://install.appcenter.ms/api/v0.1/apps/#{owner}/#{
        app
      }/distribution_groups/public/releases/#{matched['id']}"

    ohai "Fetching #{release_url}"

    resolved_url = _fetchJson(release_url)['download_url']

    ohai "Downloading from #{resolved_url}"

    curl_download resolved_url, to: temporary_path
  end
end
