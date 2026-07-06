"""
Evaluation Service — Hermes-Enhanced
Intelligent document/text evaluation with multi-criteria scoring.
"""

from typing import Optional, List
import json
import re
from datetime import datetime

from models.evaluation import EvaluationRequest, EvaluationResult


class EvaluationService:
    """
    Multi-criteria evaluation engine.
    
    Scoring criteria (total = 100):
    - Relevance (25%): How well does it address the task?
    - Depth (25%): Analysis vs description, detail level
    - Structure (20%): Organization, flow, clarity
    - Evidence (15%): Facts, data, examples, references
    - Language (15%): Grammar, vocabulary, readability
    """
    
    # Academic quality indicators
    EVIDENCE_INDICATORS = [
        "according to", "research shows", "study found", "data indicates",
        "statistics", "example", "evidence", "found that", "demonstrates",
        "percentage", "%", "million", "billion", "survey", "analysis",
        "published", "journal", "university", "professor", "researchers"
    ]
    
    STRUCTURE_INDICATORS = [
        "first", "second", "third", "finally", "in conclusion",
        "moreover", "furthermore", "however", "therefore", "thus",
        "additionally", "consequently", "as a result", "for instance"
    ]
    
    def __init__(self):
        pass
    
    async def evaluate(self, request: EvaluationRequest) -> EvaluationResult:
        """Route to appropriate evaluation method"""
        if request.text_content:
            return await self._evaluate_text(request)
        elif request.file_content:
            return await self._evaluate_file(request)
        else:
            return EvaluationResult(
                status="rejected",
                feedback="No content provided for evaluation. Please submit text or a document.",
                score=0.0
            )
    
    async def _evaluate_text(self, request: EvaluationRequest) -> EvaluationResult:
        """Intelligent text evaluation with multi-criteria scoring"""
        text = request.text_content or ""
        task_title = getattr(request, 'task_title', '') or ''
        task_description = getattr(request, 'task_description', '') or ''
        
        # Basic metrics
        word_count = len(text.split())
        sentence_count = len([s.strip() for s in re.split(r'[.!?]+', text) if s.strip()])
        paragraph_count = len([p.strip() for p in text.split('\n\n') if p.strip()])
        char_count = len(text)
        
        # Unique word ratio (vocabulary richness)
        words = [w.lower().strip('.,!?;:()') for w in text.split() if len(w) > 2]
        unique_ratio = len(set(words)) / max(len(words), 1)
        
        # Sentence length analysis
        avg_sentence_length = word_count / max(sentence_count, 1)
        
        scores = {}
        feedback_parts = []
        improvements = []
        strengths = []
        
        # ═══════════════════════════════════════════════════════
        # 1. RELEVANCE (25 points)
        # ═══════════════════════════════════════════════════════
        relevance_score = 0
        
        # Check task-related word overlap
        task_words = set()
        for w in (task_title + ' ' + task_description).lower().split():
            if len(w) > 3:
                task_words.add(w)
        
        text_words = set(w.lower().strip('.,!?;:()') for w in text.split() if len(w) > 3)
        overlap = len(task_words & text_words)
        
        if task_words:
            relevance_ratio = overlap / len(task_words)
            relevance_score = min(25, int(relevance_ratio * 25))
        else:
            # No task context — base score for coherent content
            relevance_score = 20 if word_count >= 100 else 12
        
        # Bonus for addressing the prompt directly
        if task_title and any(w in text.lower() for w in task_title.lower().split() if len(w) > 3):
            relevance_score = min(25, relevance_score + 5)
        
        scores["relevance"] = relevance_score
        if relevance_score >= 20:
            strengths.append("Strong relevance to the task topic")
        elif relevance_score < 10:
            improvements.append("Address the specific task prompt more directly")
        
        # ═══════════════════════════════════════════════════════
        # 2. DEPTH (25 points)
        # ═══════════════════════════════════════════════════════
        depth_score = 0
        
        # Word count scoring
        if word_count >= 800:
            depth_score = 25
        elif word_count >= 500:
            depth_score = 23
        elif word_count >= 300:
            depth_score = 20
        elif word_count >= 150:
            depth_score = 17
        elif word_count >= 80:
            depth_score = 14
        elif word_count >= 50:
            depth_score = 10
        else:
            depth_score = 4
        
        # Analysis indicators (vs pure description)
        analysis_words = ["because", "therefore", "however", "although", 
                         "consequently", "this means", "as a result",
                         "in contrast", "similarly", "more importantly"]
        analysis_count = sum(1 for w in analysis_words if w in text.lower())
        depth_score = min(25, depth_score + analysis_count * 3)
        
        scores["depth"] = depth_score
        if depth_score >= 20:
            strengths.append("Excellent depth with thorough analysis")
        elif depth_score >= 14:
            strengths.append("Good depth of coverage")
        elif depth_score < 10:
            improvements.append("Add more detailed analysis and explanation")
        
        # ═══════════════════════════════════════════════════════
        # 3. STRUCTURE (20 points)
        # ═══════════════════════════════════════════════════════
        structure_score = 0
        
        # Paragraph organization
        if paragraph_count >= 5:
            structure_score = 14
        elif paragraph_count >= 3:
            structure_score = 13
        elif paragraph_count >= 2:
            structure_score = 11
        elif paragraph_count >= 1:
            structure_score = 8
        else:
            structure_score = 4
        
        # Transition words
        transition_count = sum(1 for t in self.STRUCTURE_INDICATORS if t in text.lower())
        structure_score = min(20, structure_score + transition_count * 3)
        
        # Sentence variety (not all same length)
        if sentence_count > 3:
            sentences = [s.split() for s in re.split(r'[.!?]+', text) if s.strip()]
            lengths = [len(s) for s in sentences]
            if len(set(lengths)) > 1:
                structure_score = min(20, structure_score + 3)
        
        scores["structure"] = structure_score
        if structure_score >= 15:
            strengths.append("Well-organized with clear structure")
        elif structure_score < 8:
            improvements.append("Organize into clear paragraphs with topic sentences")
        
        # ═══════════════════════════════════════════════════════
        # 4. EVIDENCE (15 points)
        # ═══════════════════════════════════════════════════════
        evidence_score = 0
        
        # Check for evidence indicators
        evidence_count = sum(1 for indicator in self.EVIDENCE_INDICATORS 
                           if indicator in text.lower())
        evidence_score = min(12, evidence_count * 3)
        
        # Numbers and data
        numbers = re.findall(r'\d+', text)
        if len(numbers) >= 3:
            evidence_score = min(15, evidence_score + 3)
        elif len(numbers) >= 1:
            evidence_score = min(15, evidence_score + 1)
        
        scores["evidence"] = evidence_score
        if evidence_score >= 10:
            strengths.append("Good use of evidence and supporting data")
        elif evidence_score < 5:
            improvements.append("Include specific facts, statistics, or examples")
        
        # ═══════════════════════════════════════════════════════
        # 5. LANGUAGE (15 points)
        # ═══════════════════════════════════════════════════════
        language_score = 10  # Base score
        
        # Vocabulary richness
        if unique_ratio >= 0.7:
            language_score = 15
        elif unique_ratio >= 0.6:
            language_score = 13
        elif unique_ratio >= 0.5:
            language_score = 11
        
        # Sentence length variety (penalize very long sentences)
        if 8 <= avg_sentence_length <= 25:
            language_score = min(15, language_score + 1)
        elif avg_sentence_length > 35:
            language_score = max(5, language_score - 2)
            improvements.append("Break long sentences into shorter, clearer ones")
        
        scores["language"] = language_score
        if language_score >= 14:
            strengths.append("Clear and well-written language")
        elif language_score < 10:
            improvements.append("Work on sentence clarity and grammar")
        
        # ═══════════════════════════════════════════════════════
        # FINAL SCORE & STATUS
        # ═══════════════════════════════════════════════════════
        total_score = sum(scores.values())
        
        # Approval threshold
        if total_score >= 70:
            status = "approved"
        elif total_score >= 50:
            status = "conditional"  # Needs revision
        else:
            status = "rejected"
        
        # Build feedback
        if not strengths:
            strengths.append("Submitted the work")
        if not improvements:
            improvements.append("Keep up the good work!")
        
        # Score breakdown
        breakdown = " | ".join(f"{k}: {v}" for k, v in scores.items())
        
        feedback = f"""Score: {total_score}/100 ({breakdown})
Status: {status.upper()}

Strengths:
{chr(10).join('  • ' + s for s in strengths)}

Areas for Improvement:
{chr(10).join('  • ' + i for i in improvements)}

Summary:
Your submission contains {word_count} words across {paragraph_count} paragraphs with {sentence_count} sentences.
{f'The vocabulary richness is {unique_ratio:.0%}.' if unique_ratio else ''}
{'Keep building on these strengths!' if status == 'approved' else 'Revise and resubmit with more depth and evidence.'}"""
        
        return EvaluationResult(
            status=status,
            feedback=feedback,
            score=total_score / 100.0,  # Normalize to 0-1
            improvements=improvements if improvements else None,
            file_type=request.file_type,
            filename=request.filename
        )
    
    async def _evaluate_file(self, request: EvaluationRequest) -> EvaluationResult:
        """Evaluate uploaded file (PDF/image) — basic heuristic + metadata"""
        file_content = request.file_content or ""
        file_type = request.file_type or ""
        
        # For base64 content, check size
        if file_content:
            # Rough size estimate (base64 is ~33% larger)
            estimated_size = len(file_content) * 0.75
            
            if estimated_size < 1000:
                return EvaluationResult(
                    status="rejected",
                    feedback="File appears to be too small or empty. Please upload a complete document.",
                    score=0.2,
                    file_type=file_type,
                    filename=request.filename
                )
            
            # Basic scoring based on file presence and type
            score = 0.6  # Base score for valid upload
            
            if file_type in ["pdf", "image"]:
                score += 0.1  # Bonus for proper format
            
            if estimated_size > 10000:
                score += 0.1  # Bonus for substantive content
            
            status = "approved" if score >= 0.7 else "conditional"
            
            return EvaluationResult(
                status=status,
                feedback=f"Document received ({file_type}, ~{int(estimated_size)} bytes). {'Approved for review.' if status == 'approved' else 'Please ensure the document is complete.'}",
                score=score,
                file_type=file_type,
                filename=request.filename
            )
        
        return EvaluationResult(
            status="rejected",
            feedback="No file content received. Please re-upload.",
            score=0.0,
            file_type=file_type,
            filename=request.filename
        )
