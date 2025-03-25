package kr.t1.sts.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LOLController {

	private static final String API_KEY = "RGAPI-2cc7996a-eddb-4fa8-8291-59f14cb76f04";

	@RequestMapping(value = "/LOL", method = RequestMethod.GET)
	public String showLOLPage() {
		return "menu/LOL";
	}

	/*
	 * @RequestMapping(value = "/LOL", method = RequestMethod.POST) public String
	 * handleLOLSearch(@RequestParam("riotId") String riotId, Model model) { try {
	 * if (!riotId.contains("#")) { model.addAttribute("error",
	 * "형식이 잘못되었습니다. 예: 아이디#KR1"); return "menu/LOL"; }
	 * 
	 * String[] parts = riotId.split("#"); String gameName =
	 * URLEncoder.encode(parts[0], "UTF-8"); String tagLine =
	 * URLEncoder.encode(parts[1], "UTF-8");
	 * 
	 * String apiKey = "RGAPI-여기에-당신의-API키"; // ← 여기에 본인의 API 키 입력 // Riot API -
	 * PUUID 얻기 String url =
	 * "https://asia.api.riotgames.com/riot/account/v1/accounts/by-riot-id/" +
	 * gameName + "/" + tagLine;
	 * 
	 * HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
	 * conn.setRequestProperty("X-Riot-Token", apiKey);
	 * conn.setRequestMethod("GET");
	 * 
	 * BufferedReader reader = new BufferedReader(new
	 * InputStreamReader(conn.getInputStream())); StringBuilder response = new
	 * StringBuilder(); String line; while ((line = reader.readLine()) != null) {
	 * response.append(line); }
	 * 
	 * reader.close();
	 * 
	 * model.addAttribute("result", response.toString());
	 * 
	 * } catch (UnsupportedEncodingException e) { model.addAttribute("error",
	 * "인코딩 오류 발생: " + e.getMessage()); } catch (IOException e) {
	 * model.addAttribute("error", "API 요청 중 오류 발생: " + e.getMessage()); } catch
	 * (Exception e) { model.addAttribute("error", "기타 오류 발생: " + e.getMessage()); }
	 * 
	 * return "menu/LOL"; }
	 */
	@PostMapping("/LOL")
	public String handleLOLSearch(@RequestParam("riotId") String riotId, Model model) {

		try {

            // riotId를 "소환사이름#태그" 형태로 받음
            String[] parts = riotId.split("#");
            String gameName = parts[0];
            String tagLine = parts[1];

            // URL 공백은 %20으로 치환
            String encodedGameName = URLEncoder.encode(gameName, "UTF-8").replace("+", "%20");
            String encodedTagLine = URLEncoder.encode(tagLine, "UTF-8").replace("+", "%20");

            // API 호출 URL
            String apiUrl = "https://asia.api.riotgames.com/riot/account/v1/accounts/by-riot-id/"
                    + encodedGameName + "/" + encodedTagLine + "?api_key=" + API_KEY;

			JSONObject accountData = getJsonFromUrl(apiUrl);
			String puuid = accountData.getString("puuid");

			// puuid -> SummonerData
			String summonerUrl = "https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-puuid/" + puuid
					+ "?api_key=" + API_KEY;

			JSONObject summonerData = getJsonFromUrl(summonerUrl);
			String summonerId = summonerData.getString("id"); // 이 ID로 티어 정보 요청

			model.addAttribute("summonerInfo", summonerData);

			// 티어 정보 API
			String tierUrl = "https://kr.api.riotgames.com/lol/league/v4/entries/by-summoner/" + summonerId
					+ "?api_key=" + API_KEY;

			JSONArray tierData = getJsonArrayFromUrl(tierUrl);
			JSONObject soloTierInfo = null;

			// 솔랭
			for (int i = 0; i < tierData.length(); i++) {
				JSONObject entry = tierData.getJSONObject(i);
				if ("RANKED_SOLO_5x5".equals(entry.getString("queueType"))) {
					soloTierInfo = entry;
					break;
				}
			}

			model.addAttribute("tierInfo", soloTierInfo);

			System.out.println(summonerData);
		} catch (Exception e) {
			model.addAttribute("error", "정보를 불러오는 중 오류 발생: " + e.getMessage());
			e.printStackTrace();
		}

		return "menu/LOL";
	}

// JSON 객체 가져오기
	private JSONObject getJsonFromUrl(String urlString) throws IOException, JSONException {
		URL url = new URL(urlString);
		HttpURLConnection con = (HttpURLConnection) url.openConnection();
		con.setRequestMethod("GET");

		BufferedReader reader = new BufferedReader(new InputStreamReader(con.getInputStream()));
		StringBuilder result = new StringBuilder();
		String line;

		while ((line = reader.readLine()) != null) {
			result.append(line);
		}

		reader.close();
		return new JSONObject(result.toString());
	}

// JSON 배열 가져오기
	private JSONArray getJsonArrayFromUrl(String urlString) throws IOException, JSONException {
		URL url = new URL(urlString);
		HttpURLConnection con = (HttpURLConnection) url.openConnection();
		con.setRequestMethod("GET");

		BufferedReader reader = new BufferedReader(new InputStreamReader(con.getInputStream()));
		StringBuilder result = new StringBuilder();
		String line;

		while ((line = reader.readLine()) != null) {
			result.append(line);
		}

		reader.close();
		return new JSONArray(result.toString());
	}
}