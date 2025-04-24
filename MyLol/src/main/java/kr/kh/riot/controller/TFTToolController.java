package kr.kh.riot.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class TFTToolController {

    @GetMapping(value="/tool/tftTool", produces="application/json;charset=UTF-8")
    @ResponseBody
    public String getChampions(HttpServletRequest request) throws IOException {
        ServletContext context = request.getServletContext();
        String fullPath = context.getRealPath("/resources/json/14unit_data.json");
        return Files.readString(Paths.get(fullPath), StandardCharsets.UTF_8);
    }
}