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
            // riotId를 "소환사이름#태그" 형태로 받음
            String[] parts = riotId.split("#");
            String gameName = parts[0];
            String tagLine = parts[1];

            // URL encoding (공백은 %20으로 치환)
            String encodedGameName = URLEncoder.encode(gameName, "UTF-8").replace("+", "%20");
            String encodedTagLine = URLEncoder.encode(tagLine, "UTF-8").replace("+", "%20");

            // Riot API Key (보안상 properties에서 읽어오는 것이 이상적이나, 여기선 하드코딩)

            // API 호출 URL
            String apiUrl = "https://asia.api.riotgames.com/riot/account/v1/accounts/by-riot-id/"
                    + encodedGameName + "/" + encodedTagLine + "?api_key=" + RIOT_API_KEY;

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                String inputLine;
                StringBuilder response = new StringBuilder();

                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();

                // JSON 파싱
                JSONObject json = new JSONObject(response.toString());
                String puuid = json.getString("puuid");
                String gameNameResult = json.getString("gameName");
                String tagLineResult = json.getString("tagLine");

                model.addAttribute("puuid", puuid);
                model.addAttribute("gameName", gameNameResult);
                model.addAttribute("tagLine", tagLineResult);
                model.addAttribute("rawJson", json.toString(2));
                System.out.println(json);
            } else {
                model.addAttribute("error", "API 호출 실패: 응답 코드 " + responseCode);
            }

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "예외 발생: " + e.getMessage());
        }
        return "menu/LOL";
    }
}