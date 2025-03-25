package kr.t1.sts.controller;


import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LOLController {


	private final String RIOT_API_KEY = "RGAPI-2cc7996a-eddb-4fa8-8291-59f14cb76f04";

	
    @RequestMapping(value = "/LOL", method = RequestMethod.GET)
    public String showLOLPage() {
        return "menu/LOL";
    }
/*
    @RequestMapping(value = "/LOL", method = RequestMethod.POST)
    public String handleLOLSearch(@RequestParam("riotId") String riotId, Model model) {
        try {
            if (!riotId.contains("#")) {
                model.addAttribute("error", "형식이 잘못되었습니다. 예: 아이디#KR1");
                return "menu/LOL";
            }

            String[] parts = riotId.split("#");
            String gameName = URLEncoder.encode(parts[0], "UTF-8");
            String tagLine = URLEncoder.encode(parts[1], "UTF-8");

            String apiKey = "RGAPI-여기에-당신의-API키"; // ← 여기에 본인의 API 키 입력
            // Riot API - PUUID 얻기
            String url = "https://asia.api.riotgames.com/riot/account/v1/accounts/by-riot-id/" + gameName + "/" + tagLine;

            HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
            conn.setRequestProperty("X-Riot-Token", apiKey);
            conn.setRequestMethod("GET");

            BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }

            reader.close();

            model.addAttribute("result", response.toString());

        } catch (UnsupportedEncodingException e) {
            model.addAttribute("error", "인코딩 오류 발생: " + e.getMessage());
        } catch (IOException e) {
            model.addAttribute("error", "API 요청 중 오류 발생: " + e.getMessage());
        } catch (Exception e) {
            model.addAttribute("error", "기타 오류 발생: " + e.getMessage());
        }

        return "menu/LOL";
    }
    */
    @RequestMapping(value = "/LOL", method = RequestMethod.POST)
    public String handleLOLSearch(@RequestParam("riotId") String riotId, Model model) {
        try {
            // 1. Riot ID 분리
            String[] parts = riotId.split("#");
            if (parts.length != 2) {
                model.addAttribute("error", "형식이 잘못되었습니다. 예: 아이디#KR1");
                return "menu/LOL";
            }
            String gameName = parts[0];
            String tagLine = parts[1];

            // 2. Riot API 호출 (1단계: puuid 얻기)
           
            String accountUrl = "https://asia.api.riotgames.com/riot/account/v1/accounts/by-riot-id/"
                    + URLEncoder.encode(gameName, "UTF-8") + "/"
                    + URLEncoder.encode(tagLine, "UTF-8") + "?api_key=" + RIOT_API_KEY;

            URL url = new URL(accountUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            br.close();

            // 3. JSON 파싱 (여기!)
            JSONObject accountData = new JSONObject(sb.toString());
            String puuid = accountData.getString("puuid");

            // 다음 단계 계속...

            model.addAttribute("puuid", puuid);
            return "menu/LOL";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "API 호출 중 오류 발생: " + e.getMessage());
            return "menu/LOL";
        }
    }


}
