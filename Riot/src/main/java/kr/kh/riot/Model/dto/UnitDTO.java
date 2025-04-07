package kr.kh.riot.Model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class UnitDTO {
    private String characterId;
    private int tier;
    
    public UnitDTO() {}
}