package kr.kh.riot.Model.dto;

import java.util.List;

import lombok.Data;

@Data
public class MatchDetailDTO {
    private String matchId;
    private long gameDatetime;
    private List<ParticipantDTO> participants;
}