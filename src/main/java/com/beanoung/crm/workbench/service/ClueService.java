package com.beanoung.crm.workbench.service;

import com.beanoung.crm.workbench.mapper.ClueMapper;
import com.beanoung.crm.workbench.pojo.Clue;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.Map;

public interface ClueService {

    int saveCreateClue(Clue clue);

    List<Clue> queryClueByConditionForPage(Map<String,Object> map);

    int queryCountOfClueByCondition(Map<String,Object> map);

    int deleteClueByIds(String[] id);

    Clue queryClueById(String id);

    int saveEditClue(Clue clue);

    Clue queryClueByIdForDetail(String clueId);

    Clue queryClueByIdForConvert(String id);

    void saveConvertClue(Map<String,Object> map);
}
