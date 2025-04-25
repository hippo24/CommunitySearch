package kr.kh.riot.model.dto;

import java.util.List;

import lombok.Data;

@Data
public class MatchDTO {
    private String queueType;      // 게임 타입
    private String championName;    // 챔피언 이름
    private String championIcon;    // 챔피언 아이콘 URL
    private String spell1Icon;      // 스펠1 아이콘 URL
    private String spell2Icon;      // 스펠2 아이콘 URL
    private int champLevel;         // 챔피언 레벨
    private int kills;             // 킬
    private int deaths;            // 데스
    private int assists;           // 어시스트
    private double killParticipation; // 킬관여율
    private String items;          // 아이템들
    private int cs;                // CS
    private int gold;              // 골드
    private int visionScore;       // 시야 점수
    private String gameDuration;   // 게임 시간
    private String gameEndTime;    // 게임 종료 시간
    private boolean win;           // 승리 여부
    private String primaryRuneIcon;    // 메인 특성 아이콘
    private String secondaryRuneIcon;  // 보조 특성 아이콘
    private List<String> itemIcons; // 아이템 이미지 URL 리스트
    private List<String> firstRowItems;  // 슬롯 0,1,2,6
    private List<String> secondRowItems; // 슬롯 3,4,5

    public List<String> getItemIcons() {
        return itemIcons;
    }

    public void setItemIcons(List<String> itemIcons) {
        this.itemIcons = itemIcons;
    }

    public List<String> getFirstRowItems() {
        return firstRowItems;
    }

    public void setFirstRowItems(List<String> firstRowItems) {
        this.firstRowItems = firstRowItems;
    }

    public List<String> getSecondRowItems() {
        return secondRowItems;
    }

    public void setSecondRowItems(List<String> secondRowItems) {
        this.secondRowItems = secondRowItems;
    }
}