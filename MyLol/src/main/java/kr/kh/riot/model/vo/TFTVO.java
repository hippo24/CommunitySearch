package kr.kh.riot.model.vo;

import java.util.List;

import lombok.Data;

@Data
public class TFTVO {
    private String id;
    private String name;
    private int cost;
    private List<String> traits;
    private String image;

}
