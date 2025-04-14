package kr.kh.riot.Model.dto;

import lombok.Data;

@Data
public class SummonerDTO {
	private String puuid;
	private String summonerId;
	private String gameName;
    private String tagLine;
    private int iconId;
    private int level;

    private String tier;
    private String rank;
    private int leaguePoints;

    private int wins;
    private int losses;
    private int total;
}