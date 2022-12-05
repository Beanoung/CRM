package com.beanoung.crm.settings.service.impl;

import com.beanoung.crm.settings.mapper.DicValueMapper;
import com.beanoung.crm.settings.pojo.DicValue;
import com.beanoung.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DicValueServiceImpl implements DicValueService {

    @Autowired
    private DicValueMapper dicValueMapper;

    @Override
    public List<DicValue> queryDicValueByTypeCode(String typeCode) {
        return dicValueMapper.selectDicValueByTypeCode(typeCode);
    }
}
