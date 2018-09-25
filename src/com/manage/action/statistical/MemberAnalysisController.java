package com.manage.action.statistical;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.dao.model.MemberLabel;
import com.manage.dao.model.MemberLabelExample;
import com.manage.query.model.MemberQuery;
import com.manage.service.IMemberLabelService;
import com.manage.service.IMemberService;
import com.manage.util.DateUtil;
import com.manage.util.NumberUtil;
import com.manage.util.Pager;

@Controller
@RequestMapping(value="/member/analysis")
public class MemberAnalysisController extends BaseController{

	@Autowired
	private IMemberService memberService;
	@Autowired
	private IMemberLabelService memberLabelService;
	
	@RequestMapping(value="/index.action")
	public String index(ModelMap model){
		List<MemberLabel> levelLabels=memberLabelService.getLabelGroup("level");
		List<MemberLabel> moneyLabels=memberLabelService.getLabelGroup("money");
		List<MemberLabel> recentLabels=memberLabelService.getLabelGroup("recent");
		List<MemberLabel> repeatLabels=memberLabelService.getLabelGroup("repeat");
		List<MemberLabel> brandLabels=memberLabelService.getLabelGroup("brand");
		List<MemberLabel> sizeLabels=memberLabelService.getLabelGroup("size");
		List<MemberLabel> styleLabels=memberLabelService.getLabelGroup("style");
		List<MemberLabel> timeLabels=memberLabelService.getLabelGroup("time");
		model.put("levelLabels", levelLabels);
		model.put("moneyLabels", moneyLabels);
		model.put("recentLabels", recentLabels);
		model.put("repeatLabels", repeatLabels);
		model.put("brandLabels", brandLabels);
		model.put("sizeLabels", sizeLabels);
		model.put("styleLabels", styleLabels);
		model.put("timeLabels", timeLabels);
		return "statistic/memberAnalysis";
	}
	
	@RequestMapping(value="/searchMember.action")
	@ResponseBody
	public String searchMember(ModelMap model,MemberQuery memberQuery,Pager pager,String orderBy){
		if(StringUtils.isBlank(orderBy)){
			orderBy="registertime desc";
		}
		memberQuery.setOrderBy(orderBy);
		memberQuery.setPager(pager);
		List<MemberQuery> members=memberService.memberAnalysis(memberQuery);
		for(MemberQuery mq:members){
			MemberLabelExample memberLabelExample=new MemberLabelExample();
			memberLabelExample.createCriteria().andMemberidEqualTo(mq.getId());
			List<MemberLabel> mls=memberLabelService.selectByExample(memberLabelExample);
			mq.setMemberLabels(mls);
			mq.setDays((int)DateUtil.daysRange(mq.getLastbuytime(), new Date()));
		}
		return JSONArray.fromObject(members).toString();
	}
	
	/**
	 * 查询饼图数据
	 * @param startTime
	 * @param endTime
	 * @param brandid
	 * @return
	 */
	@RequestMapping(value="/getPieData.action")
	@ResponseBody
	public String getPieData(MemberQuery memberQuery){
		List<Map<String, Object>> brandlist=memberService.sumBrand(memberQuery);
		List<Map<String, Object>> sizelist=memberService.sumSize(memberQuery);
		List<Map<String, Object>> colorlist=memberService.sumColor(memberQuery);
		List<Map<String, Object>> stylelist=memberService.sumStyle(memberQuery);
		JSONArray legendData1=new JSONArray();
		JSONArray seriesData1=new JSONArray();
		for(Map<String, Object> m:brandlist){
			JSONObject obj=new JSONObject();
			obj.put("name", m.get("brandname"));
			obj.put("value", NumberUtil.toFixed(Double.parseDouble(m.get("totalprice").toString()), 2));
			seriesData1.add(obj);
			legendData1.add(m.get("brandname"));
		}
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("legendData_brand", legendData1);
		map.put("seriesData_brand", seriesData1);
		
		JSONArray legendData2=new JSONArray();
		JSONArray seriesData2=new JSONArray();
		for(Map<String, Object> m:sizelist){
			JSONObject obj=new JSONObject();
			obj.put("name", m.get("sizeName"));
			obj.put("value", NumberUtil.toFixed(Double.parseDouble(m.get("totalprice").toString()), 2));
			seriesData2.add(obj);
			legendData2.add(m.get("sizeName"));
		}
		map.put("legendData_size", legendData2);
		map.put("seriesData_size", seriesData2);
		
		JSONArray legendData3=new JSONArray();
		JSONArray seriesData3=new JSONArray();
		for(Map<String, Object> m:colorlist){
			JSONObject obj=new JSONObject();
			obj.put("name", m.get("colorName"));
			obj.put("value", NumberUtil.toFixed(Double.parseDouble(m.get("totalprice").toString()), 2));
			seriesData3.add(obj);
			legendData3.add(m.get("colorName"));
		}
		map.put("legendData_color", legendData3);
		map.put("seriesData_color", seriesData3);
		
		JSONArray legendData4=new JSONArray();
		JSONArray seriesData4=new JSONArray();
		for(Map<String, Object> m:stylelist){
			JSONObject obj=new JSONObject();
			obj.put("name", m.get("styleName"));
			obj.put("value", NumberUtil.toFixed(Double.parseDouble(m.get("totalprice").toString()), 2));
			seriesData4.add(obj);
			legendData4.add(m.get("styleName"));
		}
		map.put("legendData_style", legendData4);
		map.put("seriesData_style", seriesData4);
		return JSONObject.fromObject(map).toString();
	}
}
