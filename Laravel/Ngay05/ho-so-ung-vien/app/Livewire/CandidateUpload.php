<?php

namespace App\Livewire;

use Livewire\Component;
use Livewire\WithFileUploads;

class CandidateUpload extends Component
{
    use WithFileUploads;
    public $avatar;
    public function render()
    {
        return view('livewire.candidate-upload');
    }
}
