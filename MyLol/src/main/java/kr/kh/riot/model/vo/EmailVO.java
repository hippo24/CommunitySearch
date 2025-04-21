package kr.kh.riot.model.vo;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class EmailVO {
    private int ev_key;

    private String ev_email;
    private String ev_authCode;

    private LocalDateTime ev_created = LocalDateTime.now();

    private boolean ev_verified = false;
    private boolean ev_expired = false;

}
