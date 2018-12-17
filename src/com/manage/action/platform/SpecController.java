package com.manage.action.platform;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.dao.model.Spec;
import com.manage.dao.model.SpecExample;
import com.manage.service.ISequenceQueryService;
import com.manage.service.ISpecService;
import com.manage.util.Pager;

/**
 * 优惠券管理
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="spec")
public class SpecController extends BaseController{

	@Autowired
	private ISpecService specService;
	@Autowired
	private ISequenceQueryService sequenceQueryService;
	
	@RequestMapping(value="/initSpecList.action")
	public String initSpecList(){
		return "spec/speclist";
	}
	
	@RequestMapping(value="/searchSpec.action")
	@ResponseBody
	public String searchSpec(ModelMap model,Spec spec,Pager pager){
		SpecExample specExample=new SpecExample();
		SpecExample.Criteria crit=specExample.createCriteria();
		if(StringUtils.isNotBlank(spec.getSpecvalue())){
			crit.andSpecvalueLike("%"+spec.getSpecvalue()+"%");
		}
		if(StringUtils.isNotBlank(spec.getTypecode())){
			crit.andTypecodeEqualTo(spec.getTypecode());
		}
		specExample.setOrderByClause("typecode asc,sortno desc");
		specExample.setPager(pager);
		int count=specService.countByExample(specExample);
		List<Spec> specList=specService.selectByExample(specExample);
		return DataGridJson(specList, count);
	}
	
	@RequestMapping(value="/initSpecEdit.action")
	public String initSpecEdit(ModelMap model,Spec spec){
		return "spec/specEdit";
	}
	
	@RequestMapping(value="/saveSpec.action")
	@ResponseBody
	public String saveSpec(ModelMap model,Spec spec){
		if(spec.getId()==null||spec.getId()==0){		//添加
			if("color".contentEquals(spec.getTypecode())){
				spec.setTypename("颜色");
			}
			else{
				spec.setTypename("尺码");
			}
			spec.setCode(String.valueOf(sequenceQueryService.getSeqNextVal("speccode")));
			specService.insertSelective(spec);
		}
		else{		//修改
			specService.updateByPrimaryKeySelective(spec);
		}
		return "保存成功!";
	}
	
	@RequestMapping(value="/nameExists.action")
	@ResponseBody
	public String nameExists(String typecode,String specvalue){
		SpecExample specExample=new SpecExample();
		specExample.createCriteria().andTypecodeEqualTo(typecode).andSpecvalueEqualTo(specvalue);
		int count=specService.countByExample(specExample);
		if(count>0){
			return "true";
		}
		return "false";
	}
}
