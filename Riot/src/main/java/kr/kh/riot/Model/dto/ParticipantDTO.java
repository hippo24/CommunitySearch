package kr.kh.riot.Model.dto;

import java.util.List;

import lombok.Data;

@Data
public class ParticipantDTO {
    private String puuid;
    private int placement;
    private String gameName;
    private String tagLine;
    private List<UnitDTO> units;
    private List<TraitDTO> traits;
}