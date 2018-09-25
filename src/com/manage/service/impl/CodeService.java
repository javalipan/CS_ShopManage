package com.manage.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.CodeMapper;
import com.manage.dao.model.Code;
import com.manage.dao.model.CodeExample;
import com.manage.query.mapper.CodeQueryMapper;
import com.manage.service.ICodeService;

@Service
public class CodeService implements ICodeService{

	@Autowired
	private CodeMapper codeMapper;
	@Autowired
	private CodeQueryMapper codeQueryMapper;
	
	public int countByExample(CodeExample example) {
		return codeMapper.countByExample(example);
	}

	public int deleteByExample(CodeExample example) {
		return codeMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(Long id) {
		return codeMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(Code record) {
		return codeMapper.insertSelective(record);
	}

	public List<Code> selectByExample(CodeExample example) {
		return codeMapper.selectByExample(example);
	}

	public Code selectByPrimaryKey(Long id) {
		return codeMapper.selectByPrimaryKey(id);
	}

	public int updateByPrimaryKeySelective(Code record) {
		return codeMapper.updateByPrimaryKeySelective(record);
	}

	public int updateByPrimaryKey(Code record) {
		return codeMapper.updateByPrimaryKey(record);
	}

	public List<Code> getTypeList() {
		return codeQueryMapper.getTypeList();
	}

	public String getCode(String typecode) {
		CodeExample codeExample=new CodeExample();
		CodeExample.Criteria crit=codeExample.createCriteria();
		crit.andTypecodeEqualTo(typecode);
		Integer count= codeMapper.countByExample(codeExample);
		return String.format("%03d", count+1);
	}

	public List<Code> getCodesByType(String typecode) {
		CodeExample codeExample=new CodeExample();
		CodeExample.Criteria crit=codeExample.createCriteria();
		crit.andTypecodeEqualTo(typecode);
		crit.andParentidEqualTo("0");
		codeExample.setOrderByClause("sortno desc,code asc");
		List<Code> codes=codeMapper.selectByExample(codeExample);
		return codes;
	}

	public Code getCodeBycode(String code) {
		CodeExample codeExample=new CodeExample();
		codeExample.createCriteria().andCodeEqualTo(code);
		List<Code> codes=codeMapper.selectByExample(codeExample);
		if(codes.size()==1){
			return codes.get(0);
		}
		return null;
	}


}
