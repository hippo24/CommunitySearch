package kr.kh.riot.Model.vo;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class Trait {
	private String id;
    private String name;
    private String description;
    private TraitImage image;
}