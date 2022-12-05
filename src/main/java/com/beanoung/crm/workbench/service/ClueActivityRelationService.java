package com.beanoung.crm.workbench.service;

import com.beanoung.crm.workbench.mapper.ClueActivityRelationMapper;
import com.beanoung.crm.workbench.pojo.ClueActivityRelation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public interface ClueActivityRelationService {

    int createClueActivityRelation(List<ClueActivityRelation> clueActivityRelationList);

    int removeClueActivityRelation(Map<String,Object> map);

}
