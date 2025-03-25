package kr.t1.sts.model.dto;

import lombok.Data;

@Data
public class RiotSummonerDTO {
    private String gameName;
    private String tagLine;
    private String puuid;
    private String summonerId;
    private int summonerLevel;

}