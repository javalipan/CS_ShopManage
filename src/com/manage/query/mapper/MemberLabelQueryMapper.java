package com.manage.query.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.manage.dao.model.MemberLabel;

public interface MemberLabelQueryMapper {

	public List<MemberLabel> getLabelGroup(@Param("typecode")String typecode);
}
