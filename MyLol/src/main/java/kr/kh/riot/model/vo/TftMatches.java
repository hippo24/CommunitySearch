package kr.kh.riot.model.vo;

import lombok.Data;

@Data
public class TftMatches {
    private String matchId;
    private int placement;
    private int level;
    private int goldLeft;
    private int lastRound;
    private int playersEliminated;
    private int timeEliminated;
    private int totalDamageToPlayers;
    private float gameLength;
    private String companion;
    private String traits;
    private String units;
}