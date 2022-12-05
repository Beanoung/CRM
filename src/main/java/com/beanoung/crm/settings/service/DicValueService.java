package com.beanoung.crm.settings.service;

import com.beanoung.crm.settings.pojo.DicValue;

import java.util.List;

public interface DicValueService {

    List<DicValue> queryDicValueByTypeCode(String typeCode);

}
