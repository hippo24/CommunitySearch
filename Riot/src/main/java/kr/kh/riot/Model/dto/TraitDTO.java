package kr.kh.riot.Model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class TraitDTO {
	private String name;
    private int numUnits;
    private int tierCurrent;
    
    public TraitDTO(){}
}