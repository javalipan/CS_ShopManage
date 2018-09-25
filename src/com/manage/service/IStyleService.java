package com.manage.service;

import java.util.List;

import com.manage.dao.model.Style;
import com.manage.dao.model.StyleExample;

public interface IStyleService {

	int countByExample(StyleExample example);

    int deleteByExample(StyleExample example);

    int deleteByPrimaryKey(Long id);

    int insertSelective(Style record);

    List<Style> selectByExample(StyleExample example);

    Style selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Style record);

}
